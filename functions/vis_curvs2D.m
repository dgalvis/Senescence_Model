load comparison_data.mat;
load curves2D.mat;


%% Produce Curves 1-7
plot_name = {'slope sene','slope_prol','max grar','loc max grar','max apop','loc max apop','time 85% sene'};
for i = 1:7
    disp(plot_name{i});
    colorMap = [linspace(1,0,256)', linspace(1,0,256)',linspace(1,0,256)'];
    figure();clf;colormap(colorMap);grid off;
    subplot 221;hold all;
    [X,Y] = meshgrid(linspace(0,max_par(1),size(curve2D,2)),linspace(0,max_par(1),size(curve2D,3)));
    error = squeeze(curve2D(1,:,:,i));
    contourf(X,Y,error','EdgeColor','none');
    scatter(result(1),result(2),'k','filled');
    colorbar;caxis([-100,100]);
    ylabel('Pn');
    xlabel('P1');
    title('Pi->Pi+1');
    subplot 222;hold all;
    [X,Y] = meshgrid(linspace(0,max_par(2),size(curve2D,2)),linspace(0,max_par(2),size(curve2D,3)));
    error = squeeze(curve2D(2,:,:,i));
    contourf(X,Y,error','EdgeColor','none');
    scatter(result(3),result(4),'k','filled');
    colorbar;caxis([-100,100]);
    ylabel('Pn');
    xlabel('P1');
    title('Pi->GA');
    subplot 223;hold all;
    [X,Y] = meshgrid(linspace(0,max_par(3),size(curve2D,2)),linspace(0,max_par(3),size(curve2D,3)));
    error = squeeze(curve2D(3,:,:,i));
    contourf(X,Y,error','EdgeColor','none');
    scatter(result(6),result(7),'k','filled');
    colorbar;caxis([-100,100]);
    ylabel('Pn');
    xlabel('P1');
    title('Pi->A');
    subplot 224;hold all;
    [X,Y] = meshgrid(linspace(0,max_par(4),size(curve2D,2)),linspace(0,max_par(4),size(curve2D,3)));
    error = squeeze(curve2D(4,:,:,i));
    contourf(X,Y,error','EdgeColor','none');
    scatter(result(8),result(9),'k','filled');
    colorbar;caxis([-100,100]);
    title('Pi->S');
    ylabel('Pn');
    xlabel('P1');
    pause;
end
%% Produces Curves 8-14
plot_name = {'slope sene','slope_prol','max grar','loc max grar','max apop','loc max apop','time 85% sene'};
for i = 1:7
    disp(plot_name{i});
    figure();clf;
    subplot 211;hold all;
    title('Q -> S');
    xlabel('0 to 0.05');
    ylabel(['% change in ',plot_name{i}]);
    t = linspace(0,max_par(5),size(curve_flats,2));
    plot(t,curve_flats(1,:,i));
    subplot 212;hold all;
    title('A -> D');
    xlabel('0 to 0.05');
    ylabel(['% change in ',plot_name{i}]);
    t = linspace(0,max_par(5),size(curve_flats,2));
    plot(t,curve_flats(2,:,i));
    pause;
end