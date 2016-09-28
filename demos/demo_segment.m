% Segmentation demo

% Run segmentation
X = [ones(10,2); -ones(10,2)];  % state vectors
post = sem_segment(X);          % run event segmentation

% plot results
subplot(1,2,1);
imagesc(X');
xlabel('Time step','FontSize',25);
ylabel('State features','FontSize',25);
title('States','FontSize',25);
set(gca,'FontSize',20,'YTick',1:size(X,2));
for k = 1:size(X,2)-1; hold on; plot(get(gca,'XLim'),[k k]+0.5,'-k','LineWidth',4); end
subplot(1,2,2);
plot(post(:,1:2),'LineWidth',4);
title('Segmentation','FontSize',25);
legend({'Event 1' 'Event 2'},'FontSize',20,'Location','Best');
set(gca,'FontSize',20,'YLim',[-0.05 1.05],'YTick',[0 0.25 0.5 0.75 1]);
ylabel('Posterior probability','FontSize',25);
xlabel('Time step','FontSize',25)
set(gcf,'Position',[200 200 800 400])