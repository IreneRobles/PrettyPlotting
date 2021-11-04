module PrettyPlotting3

using DataFrames
using PrettyPlotting
using NoLongerProblems
using PyPlot
using PyCall

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
