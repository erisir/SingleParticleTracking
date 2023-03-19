function  [checkCount,checkboxStatus] = FindPlotHistCheckbox(handles)
%FINDPLOTHISTCHECKBOX Summary of this function goes here
%   Detailed explanation goes here
checkboxStatus = zeros(1,8); 
checkboxStatus(1) = get(handles.HistPlotCheckbox11,'Value');
checkboxStatus(2) = get(handles.HistPlotCheckbox12,'Value');
checkboxStatus(3) = get(handles.HistPlotCheckbox13,'Value');
checkboxStatus(4) = get(handles.HistPlotCheckbox14,'Value');
checkboxStatus(5) = get(handles.HistPlotCheckbox21,'Value');
checkboxStatus(6) = get(handles.HistPlotCheckbox22,'Value');
checkboxStatus(7) = get(handles.HistPlotCheckbox23,'Value');
checkboxStatus(8) = get(handles.HistPlotCheckbox24,'Value');

checkCount = sum(checkboxStatus);
end

