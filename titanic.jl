using MLJ, DataFrames, StableRNGs, CSV, Plots
plotly()
# TODO 数据探索 Exploring Data
# PassengerId => 乘客ID
# Survived => 是否存活
# Pclass => 乘客等级(1/2/3等舱位)
# Name => 乘客姓名
# Sex => 性别
# Age => 年龄
# SibSp => 堂兄弟/妹个数
# Parch => 父母与小孩个数
# Ticket => 船票信息
# Fare => 票价
# Cabin => 客舱
# Embarked => 登船港口

# TODO 数据处理 Process Data
# 0. 转换类型
# 1. 填充 Age
# 2. 填充 Embarked
# 3. Drop Cabin
# 4. 新特征
typeTransformModel(dataframe::DataFrame) = begin
  # coerce(dataframe,
  #        :Survived => Multiclass,
  #        Count => Continuous,
  #        Textual => Multiclass)
  if in("Survived", names(dataframe))
    coerce!(dataframe, :Survived => Multiclass)
  end
  
  coerce!(dataframe, Count => Continuous)
  coerce!(dataframe, Textual => Multiclass)

  return dataframe
end

fillMissingModel = FillImputer(features=[:Age, :Embarked], continuous_fill = e -> skipmissing(e) |> mode, finite_fill = e -> skipmissing(e) |> mode)

newFeatureModel!(dataframe::DataFrame) = begin
  # MODULE FeatureA 聚集 Age, Sex --> 12岁以下儿童以及妇女，12岁以上男性
  feature_filter_a(age, sex) = age >= 12 && sex == "male" ? "A" : "B"
  dataframe[!, :FeatureA] = map(feature_filter_a, dataframe[!, :Age], dataframe[!, :Sex])
  
  # MODULE FeatureB 聚集 SibSp, Parch ---> 家庭人员数量
  family_size(number) = begin
    if number == 1
      return 0
    elseif number >= 2 && number <= 4
      return 1
    else
      return 2
    end
  end

  dataframe[!, :FeatureB] = map(family_size, dataframe[!, :Parch] .+ dataframe[!, :SibSp] .+ 1)
    
  # MODULE FeatureC log(Fare + 1), encode(Pclass) -> 1, 2, 3  
  dataframe[!, :Fare] = map(floor, log.(dataframe[!, :Fare] .+ 1))
  

  # TODO don't forget to coerce scitype
  coerce!(dataframe, :FeatureA => Multiclass, :FeatureB => Continuous)
  return dataframe
end

encodeModel = OneHotEncoder(features=[:Embarked, :FeatureA])
dropUnusedModel = FeatureSelector(features = [:Age, :Sex, :SibSp, :Parch, :Cabin, :PassengerId, :Name, :Ticket], ignore=true)

# DOING debuging data process pipeline
origin_data = CSV.read("data/train.csv", DataFrame)
transformModel = @pipeline typeTransformModel fillMissingModel newFeatureModel! encodeModel dropUnusedModel

transformMachine = machine(transformModel, origin_data)
fit!(transformMachine, force=true)
output_data = MLJ.transform(transformMachine, origin_data)
schema(output_data)
# TODO 模型训练 Model Training
rng = StableRNG(1234)
using MLJLinearModels
@load LogisticClassifier pkg=MLJLinearModels
clf = LogisticClassifier()

Y, X = unpack(output_data, colname -> colname == :Survived, colname -> true)

train_row, test_row = partition(eachindex(Y), 0.7, rng=rng)
mach = machine(clf, X, Y)
fit!(mach, rows=train_row)

cv = CV(nfolds=6, rng=rng)
evaluate!(mach, rows=test_row, measures=[cross_entropy, auc], resampling=cv
)

# TODO 模型调优 Model Tuning
r_lambda = range(clf, :lambda, lower = 0.01, upper = 10.0, scale = :linear)
r_penalty = range(clf, :penalty, values = [:l1, :l2])
r_gamma = range(clf, :gamma, lower = 0, upper = 10.0, scale = :linear)

tuning = Grid(resolution = 5, rng = rng)

self_tuning_model = TunedModel(model = clf,
                               range = [r_lambda, r_penalty, r_gamma],
                               tuning = tuning,
                               resampling = CV(nfolds = 6, rng = rng),
                               measure = cross_entropy)

self_tuning_mach = machine(self_tuning_model, X, Y)
fit!(self_tuning_mach, rows=train_row, verbosity=0)
evaluate!(self_tuning_mach, rows=test_row,
          measure = [cross_entropy, auc],
          resampling = cv,
          verbosity = 0)

best_model = fitted_params(self_tuning_mach).best_model
best_mach  = machine(best_model, X, Y)

evaluate!(best_mach,
          resampling = CV(nfolds = 6, rng = rng),
          measure = [cross_entropy, area_under_curve], verbosity = 0)

# MODULE roc curve
Ŷ = predict(best_mach, X)
fprs, tprs, ts = roc(Ŷ, Y)
plot(fprs, tprs)
# TODO 投入使用 Predict 
#= MODULE data process
1. type transform
2. fill missing
3. new feature
4. encode 
5. drop unused
=#

origin_sample = CSV.read("data/test.csv", DataFrame)
# generic typeTransformModel, ignore
fillMissingModel = FillImputer(features=[:Age, :Fare], continuous_fill = e -> skipmissing(e) |> mode)

# generic new feature generate
# generic encode model
# generic drop unused
transformSampleModel = transformModel = @pipeline typeTransformModel fillMissingModel newFeatureModel! encodeModel dropUnusedModel

transformSampleMachine = machine(transformSampleModel, origin_sample)
fit!(transformSampleMachine)

output_sample = MLJ.transform(transformSampleMachine, origin_sample)

output_predict = mode.(predict(best_mach, output_sample)) |> nums -> convert(Vector{Int}, nums)

output_frame = DataFrame()
output_frame[!, :PassengerId] = convert(Vector{Int}, origin_sample[!, :PassengerId])
output_frame[!, :Survived] = output_predict
CSV.write("data/predict.csv", output_frame)
