clc;

% Input distribution
spc = [-1 1];

% Number of training examples
N = 100;

% Number of dimensions
d = 2;

% Learning rate
eta = 0.01;

% Termination criteria
threshold = 0.01;

% Maximum number of epochs. Set to 0 to run for as long as it takes
maxepochs = 0;

% Number of times the experiment will be computed
runs = 100;

% Matrix the metrics will be appended
rundata = [];

for r = 1:runs

  % Generates the training examples for this run
  [X, y, wf] = homework_5_logistic_regression_inputdata (spc, N, d);

  % Initial weights
  w = zeros (d+1, 1);

  % Runs the stochastic gradient descent algorithm
  [w, epoch] = homework_5_logistic_regression_sgd (X, y, w, eta, @homework_5_logistic_regression_xentropygrad, threshold, maxepochs);

  % Calculates the error
  err = homework_5_logistic_regression_eout (spc, 100, d, wf, w, @homework_5_logistic_regression_xentropy);

  % Updates run statistics
  rundata(r,:) = [err epoch]; %#ok<SAGROW>
end

fprintf('Eout avg = %.3f, Epochs avg = %.3f\n', mean (rundata, 1));
