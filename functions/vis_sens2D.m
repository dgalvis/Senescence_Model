load comparison_data.mat;
load sensitive2D.mat;
load('./result_files/parameters_final_best.mat');


%% Produce Sensitive Figure 1
colorMap = [linspace(1,0,256)', linspace(1,0,256)',linspace(1,0,256)'];
figure();clf;colormap(colorMap);
subplot 221;hold all;
[X,Y] = meshgrid(linspace(0,max_par(1),size(sensitive2D,2)),linspace(0,max_par(1),size(sensitive2D,3)));
error1 = squeeze(sensitive2D(1,:,:));
%contourf(X,Y,error1','EdgeColor','none');
imagesc(linspace(0,max_par(1),size(sensitive2D,2)),linspace(0,max_par(1),size(sensitive2D,2)),error1');
scatter(result(1),result(2),'k','filled');
colorbar;caxis([0,100]);
axis([0,max_par(1),0,max_par(1)]);
ylabel('Pn');
xlabel('P1');
title('Pi->Pi+1');
subplot 222;hold all;
[X,Y] = meshgrid(linspace(0,max_par(2),size(sensitive2D,2)),linspace(0,max_par(2),size(sensitive2D,3)));
error2 = squeeze(sensitive2D(2,:,:));
%contourf(X,Y,error2','EdgeColor','none');
imagesc(linspace(0,max_par(2),size(sensitive2D,2)),linspace(0,max_par(2),size(sensitive2D,2)),error2');
scatter(result(3),result(4),'k','filled');
colorbar;caxis([0,100]);
axis([0,max_par(2),0,max_par(2)]);
ylabel('Pn');
xlabel('P1');
title('Pi->GA');
subplot 223;hold all;
[X,Y] = meshgrid(linspace(0,max_par(3),size(sensitive2D,2)),linspace(0,max_par(3),size(sensitive2D,3)));
error3 = squeeze(sensitive2D(3,:,:));
%contourf(X,Y,error3','EdgeColor','none');
imagesc(linspace(0,max_par(3),size(sensitive2D,2)),linspace(0,max_par(3),size(sensitive2D,2)),error3');
scatter(result(6),result(7),'k','filled');
colorbar;caxis([0,100]);
axis([0,max_par(3),0,max_par(3)]);
ylabel('Pn');
xlabel('P1');
title('Pi->A');
subplot 224;hold all;
%subplot 224;hold all;
[X,Y] = meshgrid(linspace(0,max_par(4),size(sensitive2D,2)),linspace(0,max_par(4),size(sensitive2D,3)));
error4 = squeeze(sensitive2D(4,:,:));
%contourf(X,Y,error4','EdgeColor','none');
imagesc(linspace(0,max_par(4),size(sensitive2D,2)),linspace(0,max_par(4),size(sensitive2D,2)),error4');
scatter(result(8),result(9),'k','filled');
colorbar;caxis([0,100]);
axis([0,max_par(4),0,max_par(4)]);
title('Pi->S');
ylabel('Pn');
xlabel('P1');

%% Produce Sensitive Figure 2
figure();clf;hold all;
title('Q -> S solid/ A->D dashed');
t = linspace(0,max_par(5),size(sensitive_flats,2));
plot(t,sensitive_flats(1,:),'k');
plot([result(5),result(5)],[-10,200],'color',[0.5,0.5,0.5]);
axis([0,0.01,0,120]);


xlabel(['0 to ',num2str(max_par(5))]);
ylabel('% change in error');
t = linspace(0,max_par(5),size(sensitive_flats,2));
plot(t,sensitive_flats(2,:),'k--');
plot([result(10),result(10)],[-10,200],'--','color',[0.5,0.5,0.5]);
axis([0,0.01,0,120]);
%% Produce Sensitive Figure 3
figure();clf;hold all;
title('P in H2AX sold/G in Ki67 dashed/G in H2Ax dashdot');
xlabel('0 to 1');
ylabel('% change in error');
t = linspace(0,1,size(sensitive_fracs,2));
plot(t,sensitive_fracs(1,:),'k');
plot([result(11),result(11)],[-10,200],'color',[0.5,0.5,0.5]);
plot(t,sensitive_fracs(2,:),'k--');
plot([result(12),result(12)],[-10,200],'--','color',[0.5,0.5,0.5]);
plot(t,sensitive_fracs(3,:),'k-.');
plot([result(13),result(13)],[-10,200],'-.','color',[0.5,0.5,0.5]);
axis([0,1,0,120]);

