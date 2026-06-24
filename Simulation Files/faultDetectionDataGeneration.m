% specify the transmission lines in the transmission network
faultLineArray = ["7-8" "8-9" "9-6" "6-4" "4-5" "5-7"];

% specify types of faults
faultTypeArray = ["ABCG" "ABC" "ABG" "ACG" "BCG" "AG" "BG" "CG" "AB" "AC" "BC"];

% set fault duration
faultDuration = '[4/60  11/60]';

% open the Simulink model
open_system('IEEE_9bus_new_o');

for faultLine = faultLineArray
    % switch off all faults for all transmission lines
    faultBlock = strjoin(["IEEE_9bus_new_o/Three-Phase Fault L" faultLine], "");
    set_param(faultBlock, 'FaultA', 'off');
    set_param(faultBlock, 'FaultB', 'off');
    set_param(faultBlock, 'FaultC', 'off');
    set_param(faultBlock, 'GroundFault', 'off');

    % set the fault locations to 50km
    eval(strjoin(["L" strrep(faultLine, "-", "") "_Length = 50" ";"], ""));
end

% for each transmission line
for faultLine = faultLineArray
    % select fault block for current transmission line
    faultBlock = strjoin(["IEEE_9bus_new_o/Three-Phase Fault L" faultLine], "");
    % set duration of fault for this block
    set_param(faultBlock, 'SwitchTimes', faultDuration)

    % for each type of fault
    for faultType = faultTypeArray
        % set the type of fault to the current one
        switch faultType
            case "ABCG"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'on');
            case "ABC"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'off');
            case "ABG"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'off');
                set_param(faultBlock, 'GroundFault', 'on');
            case "ACG"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'off');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'on');
            case "BCG"
                set_param(faultBlock, 'FaultA', 'off');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'on');
            case "AG"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'off');
                set_param(faultBlock, 'FaultC', 'off');
                set_param(faultBlock, 'GroundFault', 'on');
            case "BG"
                set_param(faultBlock, 'FaultA', 'off');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'off');
                set_param(faultBlock, 'GroundFault', 'on');
            case "CG"
                set_param(faultBlock, 'FaultA', 'off');
                set_param(faultBlock, 'FaultB', 'off');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'on');
            case "AB"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'off');
                set_param(faultBlock, 'GroundFault', 'off');
            case "AC"
                set_param(faultBlock, 'FaultA', 'on');
                set_param(faultBlock, 'FaultB', 'off');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'off');
            case "BC"
                set_param(faultBlock, 'FaultA', 'off');
                set_param(faultBlock, 'FaultB', 'on');
                set_param(faultBlock, 'FaultC', 'on');
                set_param(faultBlock, 'GroundFault', 'off');
        end

        % simulate the model with the modifications
        sim('IEEE_9bus_new_o.slx');

        % save the generated data for the current configurations to a
        % csv file
        saveToCSV2(faultDetectionData, ...
            strjoin(["Datasets/Line" strrep(faultLine, "-", "") ...
            "_" string(faultType) "_Fault_Detection.csv"],""));

        disp(strjoin(["Done generating data for Line" faultLine ...
            "and type" faultType]))
    end

    % switch off all faults for current transmission line
    set_param(faultBlock, 'FaultA', 'off');
    set_param(faultBlock, 'FaultB', 'off');
    set_param(faultBlock, 'FaultC', 'off');
    set_param(faultBlock, 'GroundFault', 'off');

    % display message to show end of data generation for current line
    disp(repmat('=',1,44))
    disp(strjoin(["Done generating data for Line" faultLine]))
    disp(repmat('=',1,44))
end


% make 2 beep sounds to signify end of operation
beep
pause(2)
beep