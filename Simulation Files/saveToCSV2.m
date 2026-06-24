function saveToCSV2(structData, filename)
%saveToCSV Takes the simulation result as a structure array and saves it as
%a csv file
%   This function takes in 40 simulation signals, then save the data as a
%   csv file. The collection of csv files generated from this function
%   would form the datset to be used
dataLength = size(structData.Fault.Data, 1);
% Time = structData.Time.Data(1:dataLength);
T = table(structData.Time.Data(1:dataLength), structData.Fault.Data, ...
    reshape(structData.Detection.Data, ...
    size(structData.Detection.Data,3), 1), ...
    'VariableNames', fieldnames(structData));

writetable(T, filename);
end