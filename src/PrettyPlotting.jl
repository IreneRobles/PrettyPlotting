module PrettyPlotting

using PyPlot, PyCall

export pretty_axes, pretty_axes2, set_limits_probes_vs_probes, set_limits_area_vs_probes, legend_out_of_plot, legend_removal
export squareplot, savefigwithtext, line075black

function pretty_axes()
    axes = gca()
    axes[:spines]["top"][:set_visible](false) # Hide the top edge of the axis
    axes[:spines]["right"][:set_visible](false) # Hide the right edge of the axis
    axes[:xaxis][:set_ticks_position]("bottom")
    axes[:yaxis][:set_ticks_position]("left")
    axes[:spines]["left"][:set_position](("axes",-0.03)) # Offset the left scale from the axis
    axes[:spines]["bottom"][:set_position](("axes",-0.05)) # Offset the bottom scale from the axis
end


function pretty_axes2()
    ax = gca()
    ax[:spines]["top"][:set_visible](false)
    ax[:spines]["right"][:set_visible](false)
end

function set_limits_probes_vs_probes(n; # Where n is the number of dataframes to plot
    lim_probe1 = 150,
    lim_probe6 = 60,
    lim_area = 80000,
    lim_probe4 = 400
    )
    for i in 1:n
    subplot(3, n, i)
    ylim(0, lim_probe4)
    xlim(0, lim_probe1)
    pretty_axes()

    subplot(3, n, i+n)
    ylim(0, lim_probe4)
    xlim(0, lim_probe6)
    pretty_axes()

    subplot(3, n, i+n*2)
    ylim(0, lim_probe1)
    xlim(0, lim_probe6)
    pretty_axes()
    end
end

function set_limits_area_vs_probes(n; # Where n is the number of dataframes to plot
    lim_probe1 = 150,
    lim_probe6 = 60,
    lim_area = 80000,
    lim_probe4 = 400
    )
    for i in 1:n
    subplot(3, n, i)
    ylim(0, lim_probe4)
    xlim(0, lim_area)
    pretty_axes()

    subplot(3, n, i+n)
    ylim(0, lim_probe1)
    xlim(0, lim_area)
    pretty_axes()

    subplot(3, n, i+n*2)
    ylim(0, lim_probe6)
    xlim(0, lim_area)
    pretty_axes()
    end
end

function legend_out_of_plot()
    ax = gca()
    ax[:legend](loc="center left", bbox_to_anchor=(1, 0.5))
end

function legend_removal()
    ax = gca()
    handles,labels = ax[:get_legend_handles_labels]()
    handles = []
    labels = []
    legend(handles,labels, frameon = false)
end

function squareplot()
    ax = gca()
    ax.set_aspect(1.0/ax.get_data_ratio(), adjustable="box")

end

function savefigwithtext(figname)
        
    py"""
import matplotlib as mpl

new_rc_params = {'text.usetex': False,
"svg.fonttype": 'none'
}
mpl.rcParams.update(new_rc_params)
import matplotlib.pyplot as plt
plt.savefig($figname)
"""

end

function line075black()
    ax = gca()
    for artist in ax.artists
        artist.set_edgecolor("black")
        artist.set_linewidth(0.75)
        line = ax.lines
        for l in line
        l.set_color("black")
        l.set_linewidth(0.75)
        end
    end
end



# Old function from PrettyPlotting2 that I do not think I am ever going to use again
"""
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


"""

end
