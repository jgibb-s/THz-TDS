function [figs] = plot_from_cell_nu_amp(spec_cell, sample_cell, offset, stretch_factor)

 if nargin < 4
    stretch_factor = 1;
 end


if nargin < 3
    offset = 0;
    stretch_factor = 1;
end

 


n = size(spec_cell ,1);
figs = gobjects(2,1);        % cell for individual plot handles





%%
% % my_colors = {'dark blue', 'reddish', 'forest green', 'bronze', 'baby purple',...
% %                 'cinnamon', 'dusty green', 'magenta', 'grey'};
% my_colors = {'blue', 'reddish', 'forest green', 'bronze', 'purple',...
%                 'black', 'dusty green', 'magenta', 'grey', 'coral'};

%%

figs(1) = figure;
figs(2)  = axes('Parent', figs(1,1));
hold on;
for k = 1: n
    

    plt = plot(figs(2), spec_cell{k}(:,1),  stretch_factor *spec_cell{k}(:,2)+ (k-1)*offset  );
   % plt.Color = rgb(my_colors{k});
    plt.Color(4) = 0.90;
   % plt.LineWidth = 2;
end
    hold off
    xlabel('$\nu$ (THz)', 'Interpreter', 'latex')
    ylabel('$|E|$ (AU)', 'Interpreter', 'latex')
    legend(sample_cell)
    xlim([0 3])
        
%% 
if n>1 && offset ~= 0
    str = ['successive plots offset by ', num2str(offset), 'AU along y-axis'];
title(figs(2), str)
end



end