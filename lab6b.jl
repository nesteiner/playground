using MLJ, StableRNGs
import RDatasets: dataset
using PrettyPrinting
import Distributions

linearRegressor = @load LinearRegressor pkg=MLJLinearModels
ridgeRegressor  = @load RidgeRegressor  pkg=MLJLinearModels
lassoRegressor  = @load Lassoregressor  pkg=MLJLinearModels

hitters = dataset("ISLR", "Hitters")
names(hitters) |> pprint

y, X = unpack(hitters, ==(:Salary), colname -> true)
nomissing = map(!ismissing, y)
y = skipmissing(y) |> collect
X = X[nomissing, :]

rng = StableRNG(1234)
train, test = partition(eachindex(y), 0.7, rng=rng)

using Plots
plotly()
plot(y, markder="o")
