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

export violin_color, color_boxplot

function violin_color(violinplot, color)
     for pc in violinplot["bodies"]
        pc[:set_facecolor](color)
    end
end


function color_boxplot(boxp; color = "black", facecolor = "blue", linewidth = 2, alpha = 0.7)
    for box in boxp["boxes"]
    # change outline color
    box[:set](color = color, linewidth=linewidth)
    # change fill color
    box[:set](facecolor = facecolor , alpha = alpha)
    end
    
    for whisker in boxp["whiskers"]
        whisker[:set]( color=color, alpha=0.5, linewidth=linewidth)
    end
    for cap in boxp["caps"]
        cap[:set](color=color, linewidth=linewidth)
    end
    
end



export tight_layout

function tight_layout(; pad=3, w_pad=2, h_pad=2)
  plt[:tight_layout](pad=pad, w_pad=w_pad, h_pad=h_pad)
end

export colors_for_wt, colors_for_ko

function colors_for_wt()
    return ["darkblue", "blue", "lightblue"]
end

function colors_for_ko()
    return ["#d17600", "#ffc551", "#ffe13d"]
end

export legend_show_this_elements_and_in_this_order, legend_help, jitter_plot

function legend_help(norep; loc = "center right")
    ax = gca()
    handles, labels = ax[:get_legend_handles_labels]()
    legend(handles[norep], labels[norep], loc=loc, bbox_to_anchor=(0.999, 0.5))
end

function legend_show_this_elements_and_in_this_order(norep; loc = "center right")
    ax = gca()
    handles, labels = ax[:get_legend_handles_labels]()
    legend(handles[norep], labels[norep], loc=loc, bbox_to_anchor=(0.999, 0.5))
end

export prepare_data_for_rainplot, colour_data_for_rainplot, half_violins

function prepare_data_for_rainplot(df, feature, unique_col, ordering)
    sort_df = sort!(df, cols = ordering, rev = false)
    samples_df = unique(sort_df[:Sample])
    dfs = NoLongerProblems.split_by(df, :Sample)
    [dfs[sam][feature] for sam in samples_df]
end

function colour_data_for_rainplot(df, feature, unique_col, ordering, color_by = :Genotype, pallette = Dict("WT" => "blue", "Rad21KO" => "orange"))
    sort_df = sort!(df, cols = ordering, rev = false)
    samples_df = unique(sort_df[:Sample])
    dfs = NoLongerProblems.split_by(df, :Sample)
    colors = [unique(dfs[sam][color_by])[1] for sam in samples_df]
    colors = [pallette[c] for c in colors]
end


function half_violins(vioplot)
    py"""
import matplotlib.pyplot as plt
import numpy as np
    
for b in $vioplot["bodies"]:
    m = np.mean(b.get_paths()[0].vertices[:, 0])
    b.get_paths()[0].vertices[:, 0] = np.clip(b.get_paths()[0].vertices[:, 0], -np.inf, m)
    """
    
    py"$vioplot"
    
end

function jitter_plot(dat, colors; positions = 1:length(d))
    i = 0
    for d in dat
        i += 1
        x = fill(positions[i], length(d))
        x = [i + rand(0:0.001:0.3) for i in  x]
        scatter(x, d, c = colors[i], s = 2, alpha = 0.1)
    end
end


end
