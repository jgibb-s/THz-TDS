function [fig_t] = plot_from_cell_t(data_cell, sample_cell, y_offset, x_offset)

% Default:
% y_offset = 10
% x_offset = 7
if nargin < 3
    y_offset = 0;
    x_offset = 0;
end

if nargin < 4
       x_offset = 0;
end

n = length(data_cell);
fig_t = gobjects(2,1);        % cell for fig and axes handles


fig_t(1) = figure; 
fig_t(2)  = axes('Parent', fig_t(1));

%%
%my_colors = {'dark blue', 'reddish', 'forest green', 'bronze', 'purple',...
%                 'black', 'dusty green', 'magenta', 'grey', 'coral'};
%%
hold on;
for k = 1: n
    plt = plot(data_cell{k}(:,1) + (k-1)*x_offset,  data_cell{k}(:,2)+ (k-1)*y_offset  );
    %plt.Color = rgb(my_colors{k});
    plt.Color(4) = 0.90;
end
hold off;
    
xlabel('t (ps)', 'Interpreter', 'latex')
ylabel('$\widetilde{E}(t)$ (AU)', 'Interpreter', 'latex')
legend(sample_cell)
%legend('Location', 'best')
if n>1 && y_offset ~= 0 && x_offset ==0
    str = ['plots offset by ', num2str(y_offset), ' AU'];
     
    txt = text(1.05, 0.225, str, 'Units', 'Normalized', 'Interpreter', 'LaTex');
    txt.Rotation = 90;
    txt.FontSize = 14;
else if n>1 && y_offset ~= 0 && x_offset ~=0

str = ['plots offset by (', num2str(x_offset),',',num2str(y_offset), ') units'];
     
    txt = text(1.05, 0.13, str, 'Units', 'Normalized','Interpreter', 'LaTex');
    txt.Rotation = 90;
    txt.FontSize = 14;

end

end