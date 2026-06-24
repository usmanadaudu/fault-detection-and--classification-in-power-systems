% load the full dataset
fullDataset = readtable("Datasets\full_dataset.csv");

% define the predictors and the response data
predictorData = fullDataset(fullDataset.faultIndicator == 1,5:end);
responseData = fullDataset(fullDataset.faultIndicator == 1,{'faultLocation'});

% split data into training and test sets
cv = cvpartition(size(predictorData, 1),'HoldOut', 0.2);
trainIndex = training(cv);
testIndex = test(cv);

trainPredictorData = predictorData(trainIndex, :);
trainResponseData = responseData(trainIndex, :);
testPredictorData = predictorData(testIndex, :);
testResponseData = responseData(testIndex, :);

% train a decision tree model on the dataset
treeModel = fitrtree(trainPredictorData, trainResponseData);

% check the model performance
modelLoss = loss(treeModel, testPredictorData, testResponseData);
disp(['Model MSE: ', num2str(modelLoss)]);

% save the model
save('faultLocationModel.mat', 'treeModel');

% make 2 beep sounds to signify end of operation
beep
pause(2)
beep
