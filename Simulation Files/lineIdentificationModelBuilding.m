% load the full dataset
fullDataset = readtable("Datasets\full_dataset.csv");

% define the predictors and the response data
predictorData = fullDataset(fullDataset.faultIndicator == 1,5:end);
responseData = fullDataset(fullDataset.faultIndicator == 1,{'faultLine'});
responseData = categorical(responseData{:,:});

% split data into training and test sets
cv = cvpartition(size(predictorData, 1),'HoldOut', 0.2);
trainIndex = training(cv);
testIndex = test(cv);

trainPredictorData = predictorData(trainIndex, :);
trainResponseData = responseData(trainIndex, :);
testPredictorData = predictorData(testIndex, :);
testResponseData = responseData(testIndex, :);

% train a decision tree model on the dataset
treeModel = fitcecoc(trainPredictorData, trainResponseData);

% check the model performance
predictions = predict(treeModel, testPredictorData);
accuracy = sum(predictions == testResponseData)/(length(testResponseData));
disp(['Model Accuracy: ', num2str(accuracy * 100), '%']);

figure()
confusionchart(testResponseData, predictions, 'Normalization', ...
    'row-normalized');
titleString = ["Confusion Matrix for Line Identification";...
    strjoin(["Overall Accuracy = " num2str(accuracy*100) "%"], "")];
title(titleString);

% save the model
save('lineIdentificationModel_svm.mat', 'treeModel');

% make 2 beep sounds to signify end of operation
beep
pause(2)
beep
