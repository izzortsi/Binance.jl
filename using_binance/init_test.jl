# %%

using Binance: Futures
# %%
  
using Dates, DataFrames
# %%

hr24 = Futures.get24HR()
# %%
hr24[1]

# %%

hr24ETHBTC = Futures.get24HR("ETHUSDT")
# %%


# %%

function getBinanceKlineDataframe(symbol; startDateTime = nothing, endDateTime = nothing, interval="1m")
    klines = Futures.getKlines(symbol; startDateTime = startDateTime, endDateTime = endDateTime, interval = interval)
    result = hcat(map(z -> map(x -> typeof(x) == String ? parse(Float64, x) : x, z), klines)...)';

    if size(result,2) == 0
        return nothing
    end

    symbolColumnData = map(x -> symbol, collect(1:size(result, 1)));
    df = DataFrame([symbolColumnData, Dates.unix2datetime.(result[:,1]/1000) ,result[:,2],result[:,3],result[:,4],result[:,5],result[:,6],result[:,8],Dates.unix2datetime.(result[:,7] / 1000),result[:,9],result[:,10],result[:,11]], [:symbol,:startDate,:open,:high,:low,:close,:volume,:quoteAVolume, :endDate, :trades, :tbBaseAVolume,:tbQuoteAVolume]);
end
# %%

dfKlines = getBinanceKlineDataframe("ETHBTC");

# %%
using WGLMakie
# %%


lines(dfKlines[!, :close];label="ETHBTC interval = '1m'")