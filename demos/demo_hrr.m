% Demonstration of holographic reduced representations, using example from
% p. 15 of Stewart & Eliasmith (2012) book chapter.

% figure out how many dimensions we need
N = 10;     % vocabulary size
K = 5;      % maximum number of terms to be combined
err = 0.01; % error probability
D = plate_formula(N,K,err);

% embed symbols in vector space
distr = 'spikeslab_gaussian';   % distribution of embedding vectors
param = [1 1];                  % parameters of the embedding distribution
dog = embed(1,D,distr,param);
agent = embed(1,D,distr,param);
chase = embed(1,D,distr,param);
verb = embed(1,D,distr,param);
cat = embed(1,D,distr,param);
patient = embed(1,D,distr,param);

% construct a sentence and query the agent role
sentence = encode(dog,agent) + encode(chase,verb) + encode(cat,patient);
dog_decoded = decode(sentence,agent);

% visualize the accuracy of the decoded vector
scatter(dog,dog_decoded); lsline
xlabel('Embedded vector','FontSize',20);
ylabel('Decoded vector','FontSize',20);