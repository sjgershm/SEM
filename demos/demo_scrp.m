% Plot simulations of sticky Chinese restaurant process.

rng(2);

M = 20;
N = 50;
alpha = [1 20];
lambda = [0 100];
concentration = {'Low' 'High'};
sticky = {'Low' 'High'};

v = 0;
for i = 1:length(alpha)
    for j = 1:length(lambda)
        v = v + 1;
        for m = 1:M; e(m,:) = scrp_sim(N,alpha(i),lambda(j)); end
        subplot(length(alpha),length(lambda),v);
        imagesc(e); colormap colorcube
        xlabel('Time','FontSize',20);
        ylabel('Sequence','FontSize',20);
        set(gca,'FontSize',18,'XTick',[],'YTick',[]);
        title(['Concentration: ',concentration{i},', Stickiness: ',sticky{j}],'FontSize',25,'FontWeight','Bold')
    end
end