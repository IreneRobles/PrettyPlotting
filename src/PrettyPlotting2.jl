module PrettyPlotting2
using EdgeDataFrames
using PyPlot
using PrettyPlotting

export plot_pyramide_distribution

function plot_pyramide_distribution(edf::EdgeDataFrame, symbol;
    c_ = "blue",
    title_ = "title_",
    ylab = string(symbol))
    stdata = edf.prop
    boxes = 0
    d = convert(Array{Int, 1}, stdata[symbol])
    o = maximum(unique(d))
    o = length(0:o)
    if o > boxes
        boxes = o
        if o> 150
            boxes = 150
        end
    end
    range = 0:boxes
    data2 = counts(d, range)
    plt[:barh](range, data2, color = c_, align = "center", lw = 0)
    plt[:barh](range, -data2, color = c_, align = "center", lw = 0)
    xticks([],[])
    pretty_axes()
    title(title_)
    ylabel(ylab)
    ax = gca()
end



end
