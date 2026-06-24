% load the full dataset
fullDataset = readtable("Datasets\full_dataset.csv");

% combine label both ABC and ABCG faults as SymFault
symInd = (fullDataset.faultType == "ABCG" | fullDataset.faultType == "ABC");
fullDataset.faultType(symInd) = {'symFault'};

% define the predictors and the response data
predictorData = fullDataset(fullDataset.faultIndicator == 1,5:end);
responseData = fullDataset(fullDataset.faultIndicator == 1,{'faultType'});
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
treeModel = fitctree(trainPredictorData, trainResponseData);

% check the model performance
predictions = predict(treeModel, testPredictorData);
accuracy = sum(predictions == testResponseData)/(length(testResponseData));
disp(['Model Accuracy: ', num2str(accuracy * 100), '%']);

confusionchart(testResponseData, predictions, 'Normalization', ...
    'row-normalized');
titleString = ["Confusion Matrix for Line Identification";...
    strjoin(["Overall Accuracy = " num2str(accuracy*100) "%"], "")];
title(titleString);

% save the model
save('typeIdentificationModelV2.mat', 'treeModel');

% make 2 beep sounds to signify end of operation
beep
pause(2)
beep
