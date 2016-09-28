% Reconstructive memory demo

% run segmentation
opts = sem_opts;
X = [ones(10,2); -ones(10,2)];      % state vectors
[post, SEM] = sem_segment(X,opts);  % run event segmentation

% reconstruct memory from corrupted input
x1 = [1 1];
x2 = [0.5 1.5];
e1 = 1;
[x2r, x2p] = sem_reconstruct(x1,x2,e1,opts,SEM);

% plot results
bar([x2; x2p; x2r]); colormap bone
set(gca,'FontSize',20,'XTickLabel',{'Trace' 'Prediction' 'Reconstruction'},'YLim',[0 1.6]);
ylabel('Activation value (a.u.)','FontSize',20);
legend({'Unit 1' 'Unit 2'},'FontSize',20);