function results = sem_sim(sim,varargin)
    
    % Run simulations.
    %
    % USAGE: results = SEM_sim(sim,varargin)
    
    % set random number generator seed for reproducibility
    rng(1);
    
    switch sim
        
        case 'structure_demo'
            
            % embed symbols in vector space
            D = 100;
            distr = 'spikeslab_gaussian';   % distribution of embedding vectors
            param = [1 1];                  % parameters of the embedding distribution
            verb = embed(1,D,distr,param);
            agent = embed(1,D,distr,param);
            patient = embed(1,D,distr,param);
            ask = embed(1,D,distr,param);
            answer = embed(1,D,distr,param);
            tom = embed(1,D,distr,param);
            charan = embed(1,D,distr,param);
            micah = embed(1,D,distr,param);
            ken = embed(1,D,distr,param);
            
            % generate event sequence
            nRep = 1;
            event1 = [encode(agent,tom) + encode(patient,charan) + encode(verb,ask); ...
                encode(agent,charan) + encode(patient,tom) + encode(verb,answer)];
            event2 = [encode(agent,tom) + encode(patient,charan) + encode(verb,ask); ...
                encode(agent,tom) + encode(patient,charan) + encode(verb,answer)];
            event3 = [encode(agent,micah) + encode(patient,ken) + encode(verb,ask); ...
                encode(agent,ken) + encode(patient,micah) + encode(verb,answer)];
            event4 = [encode(agent,micah) + encode(patient,ken) + encode(verb,ask); ...
                encode(agent,micah) + encode(patient,ken) + encode(verb,answer)];
            X = repmat(event1,nRep,1);
            
            % set options (for this example, restrict to one event)
            opts.alpha = 0;
            opts.eta = 0.2;
            opts = sem_opts(opts);
            
            % run inference
            [results.post1, results.SEM] = sem_segment(X,opts);
            
            % generate predictions
            x1 = opts.f(event1(1,:),results.SEM.theta(1,:));
            x2 = opts.f(event2(1,:),results.SEM.theta(1,:));
            x3 = opts.f(event3(1,:),results.SEM.theta(1,:));
            x4 = opts.f(event4(1,:),results.SEM.theta(1,:));
            
            % compute distances
            d = 'cosine';
            Y(1,1) = pdist([x1; event1(2,:)],d);
            Y(2,1) = pdist([x2; event2(2,:)],d);
            Y(1,2) = pdist([x3; event3(2,:)],d);
            Y(2,2) = pdist([x4; event4(2,:)],d);
            
            % plot results
            bar(Y'); colormap autumn
            set(gca,'XTickLabel',{'Training' 'Test'},'FontSize',25,'XLim',[0.5 2.5],'YLim',[0.7 1.3])
            set(gcf,'Position',[200 200 800 400])
            ylabel('Cosine distance','FontSize',25);
            xlabel('Variables','FontSize',25);
            legend({'Correct role' 'Incorrect role'},'FontSize',25);
        
        case 'prediction1'
            
            % embed symbols in vector space
            D = 10; % dimensionality
            distr = 'spikeslab_gaussian';   % distribution of embedding vectors
            param = [1 1];                  % parameters of the embedding distribution
            role1 = embed(1,D,distr,param);
            role2 = embed(1,D,distr,param);
            role3 = embed(1,D,distr,param);
            filler1 = embed(1,D,distr,param);
            filler2 = embed(1,D,distr,param);
            
            % generate action sequence
            nRep = 1;
            event1 = [encode(role1,filler1); encode(role2,filler1)];
            event2 = [encode(role1,filler1); encode(role3,filler1)];
            event3 = [encode(role1,filler2); encode(role2,filler2)];
            X = repmat(event1,nRep,1);
            
            % set options
            opts.eta = 0.01;
            opts.beta = 1;
            opts.lambda = 10;
            opts.alpha = 0.1;
            
            % run segmentation
            [results.post1, SEM] = sem_segment(X,opts);
            
            % test trials
            results.post2 = sem_segment(event2,opts,SEM);
            results.post3 = sem_segment(event3,opts,SEM);
            results.SEM = SEM;
            
            % plot results
            bar([results.post2(2,1) results.post3(2,1)]);
            colormap bone
            set(gca,'FontSize',25,'XLim',[0.5 2.5],'XTickLabel',{'Role' 'Filler'})
            xlabel('Violation type','FontSize',25);
            ylabel('P(same event)','FontSize',25);
            
        case 'prediction2'
            
            % embed symbols in vector space
            D = 10; % dimensionality
            distr = 'spikeslab_gaussian';   % distribution of embedding vectors
            param = [1 1];                  % parameters of the embedding distribution
            role1 = embed(1,D,distr,param);
            role2 = embed(1,D,distr,param);
            role3 = embed(1,D,distr,param);
            filler1 = embed(1,D,distr,param);
            filler2 = embed(1,D,distr,param);
            filler3 = embed(1,D,distr,param);
            
            % generate action sequence
%             event1a = [encode(role1,filler1); encode(role2,filler2)];
%             event1b = [encode(role1,filler1); encode(role2,filler1)];
%             event2 = [encode(role1,filler1); encode(role2,filler3)];
            event1a = [encode(role1,filler1); encode(role1,filler3)];
            event1b = [encode(role1,filler1); encode(role2,filler3)];
            event2 = [encode(role1,filler1); encode(role3,filler3)];
            
            % set options
            opts.eta = 0.01;
            opts.beta = 1;
            opts.lambda = 10;
            opts.alpha = 0.1;
            
            % run segmentation
            [results.post1a, results.SEM1a] = sem_segment(event1a,opts);
            [results.post1b, results.SEM1b] = sem_segment(event1b,opts);
            
            % test trials
            results.post2a = sem_segment(event2,opts,results.SEM1a);
            results.post2b = sem_segment(event2,opts,results.SEM1b);
            
            % plot results
            bar([results.post2a(2,1)+1e-5 results.post2b(2,1)]);
            colormap bone
            set(gca,'FontSize',25,'XLim',[0.5 2.5],'XTickLabel',{'Low' 'High'})
            xlabel('Filler variability','FontSize',25);
            ylabel('P(same event)','FontSize',25);
            
        case 'HR14'
            % Hsieh et al. (2014), Neuron.
            
            if nargin == 1
                param = [0 1e-2; 20 100];
                %param = [20 1e-2; 20 100];
                for i = 1:size(param,1)
                    results(i) = SEM_sim('HR14',param(i,1),param(i,2));
                    y(1,:) = [mean(results(i).same_obj_pos(1:5)) mean(results(i).lag1(1:5))];
                    y(2,:) = [results(i).same_pos_rand results(i).diff_pos_rand];
                    %y(3,:) = [results(i).same_obj_rand results(i).diff_obj_rand];
                    subplot(1,2,i);
                    bar(y); colormap bone
                    %set(gca,'YLim',[0 1],'FontSize',25,'XTickLabel',{'obj+pos' 'pos' 'obj'});
                    set(gca,'YLim',[0 0.5],'FontSize',25,'XTickLabel',{'obj+pos' 'pos'});
                    if i==1; legend({'same' 'diff'},'FontSize',25); end
                    L = ['\lambda = ',num2str(param(i,1)),', \alpha = ',num2str(param(i,2))];
                    title(L,'FontSize',25);
                    ylabel('P(same event)','FontSize',25);
                end
                set(gcf,'Position',[200 200 1000 400])
                return
            end
            
            % embed symbols in vector space
            D = 10; % dimensionality
            distr = 'spikeslab_gaussian';   % distribution of embedding vectors
            param = [1 1];                  % parameters of the embedding distribution
            for i = 1:5
                sp(:,i) = embed(1,D,distr,param);   % serial position vectors
            end
            for i = 1:25
                obj(:,i) = embed(1,D,distr,param);   % obj vectors
            end
            
            % set parameters
            nRep = 3;   % number of repetitions
            opts.beta = 0.1;
            opts.alpha = varargin{2};
            opts.lambda = varargin{1};
            
            % construct sequences
            X = []; object = []; position = []; sequence = []; repetition = [];
            for rep = 1:nRep
                
                % object order
                O(1,:) = 1:5;                               % fixed
                O(2,:) = 6:10;                              % X1
                O(3,:) = [11 7 8 12 13];                    % X2
                O(4,:) = 14:18;                             % Y1
                O(5,:) = [14 15 16 19 20];                  % Y2
                O(6,:) = 21:25; O(6,:) = O(6,randperm(5));  % random
                
                % randomize sequence order
                order = randperm(6);
                O = O(order,:);
                
                for i = 1:size(O,1)
                    for j = 1:size(O,2)
                        X = [X; encode(sp(:,j),obj(:,O(i,j)))];
                        object = [object; O(i,j)];
                        position = [position; j];
                        sequence = [sequence; order(i)];
                        repetition = [repetition; rep];
                    end
                end
            end
            
            % run event segmentation
            post = sem_segment(X,opts);
            
            % representational similarity analysis
            for seq = 1:6
                n = 0;
                for r1 = 1:nRep
                    for r2 = (r1+1):nRep
                        n = n + 1;
                        
                        % similarity based on serial position
                        for p1 = 1:5
                            for p2 = 1:5
                                ix1 = position==p1 & repetition==r1 & sequence==seq;
                                ix2 = position==p2 & repetition==r2 & sequence==seq;
                                Sim_pos{seq}(n,p1,p2) = post(ix1,:)*post(ix2,:)';
                            end
                        end
                        
                        % similarity based on object identity
                        for o1 = 1:25
                            for o2 = 1:25
                                ix1 = object==o1 & repetition==r1 & sequence==seq;
                                ix2 = object==o2 & repetition==r2 & sequence==seq;
                                if any(ix1) && any(ix2)
                                    Sim_obj{seq}(n,o1,o2) = post(ix1,:)*post(ix2,:)';
                                else
                                    Sim_obj{seq}(n,o1,o2) = 0;
                                end
                            end
                        end
                    end
                end
                
                % average across repetition-pairs
                Sim_pos{seq} = squeeze(nanmean(Sim_pos{seq}));
                Sim_obj{seq} = squeeze(nanmean(Sim_obj{seq}));
                
                % collect summary statistics
                results.same_obj_pos(seq) = mean(diag(Sim_pos{seq}));
                for p = 1:5
                    
                    % lag-1
                    ix = [p-1 p+1];
                    ix(ix>5 | ix<1) = [];
                    results.lag1(p,seq) = nanmean(Sim_pos{seq}(p,ix));
                    
                    % lag-2+
                    ix = 1:5;
                    ix1 = [p-1 p p+1];
                    ix1(ix1>5 | ix1<1) = [];
                    ix(ix1) = [];
                    results.lag2(p,seq) = nanmean(Sim_pos{seq}(p,ix));
                end
                results.lag1 = nanmean(results.lag1);
                results.lag2 = nanmean(results.lag2);
                
                if seq == 6
                    
                    % same vs. diff obj (random sequence only)
                    for i = 21:25
                        results.same_obj_rand(i-20) = Sim_obj{seq}(i,i);
                        ix = 21:25; ix(ix==i) = [];
                        results.diff_obj_rand(i-20) = nanmean(Sim_obj{seq}(i,ix));
                    end
                    results.same_obj_rand = mean(results.same_obj_rand);
                    results.diff_obj_rand = mean(results.diff_obj_rand);
                    
                    % same vs. diff pos (random sequence only)
                    for i = 1:5
                        results.same_pos_rand(i) = Sim_pos{seq}(i,i);
                        ix = 1:5; ix(ix==i) = [];
                        results.diff_pos_rand(i) = nanmean(Sim_pos{seq}(i,ix));
                    end
                    results.same_pos_rand = mean(results.same_pos_rand);
                    results.diff_pos_rand = mean(results.diff_pos_rand);
                end
            end
            
            results.Sim_pos = Sim_pos;
            results.Sim_obj = Sim_obj;
    end