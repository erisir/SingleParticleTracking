function  PlotFitParameters(handles)
%PLOTFITPARAMETERS 此处显示有关此函数的摘要
%   此处显示详细说明
    global gTraces;
    time_per_framems = str2double(get(handles.Frame_Expusure_Timems,'String'))+str2double(get(handles.Frame_Transfer_Timems,'String'));
    time_per_frames = time_per_framems/1000;

    index = 1:gTraces.moleculenum;
    all = GetTracesDescribe(index,time_per_frames); 
    figure;
    rows = 1;
    columns = 3;
    subplot(rows,columns,1);
    HistAndFit(all.intensity,'gauss1',[0,5,2000],'Intensity(a.u.)'); 
    subplot(rows,columns,2);
    HistAndFit(all.meanfitError,'gauss1',[1,0.5,15],' Fit Error(nm)');
    subplot(rows,columns,3);
    HistAndFit(all.totalBindDuration,'exp1',[20,10,400],' totalBindDuration(s)');
end

