function ShowFiducialMarker(handles)
% hObject    handle to ShowFiducialMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
if ~isfield(gTraces.Config,'fiducialMarkerIndex')
     LogMsg(handles,"You need to find fiducial marker first!");
     beep();
     return;
end
figure('name',gTraces.fileName);

handle = subplot(1,1,1);

fiducialIndex = gTraces.Config.fiducialMarkerIndex ;
driftx = gTraces.driftx;
drifty = gTraces.drifty;

driftx = abs(driftx - driftx(end));
drifty = abs(drifty - drifty(end));

colNums = ceil(size(fiducialIndex,2)/2);
sx = gTraces.smoothDriftx; 
sy = gTraces.smoothDrifty;
hold on;
plot(handle,abs(sx-sx(end)),abs(sy-sy(end)),'k*','markersize',6);
plot(handle,abs(sx-sx(end)),abs(sy-sy(end)),'k','markersize',6);

%plot(handle,driftx,drifty,'k*','markersize',10);
str = ["smooth"];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,abs(x-x(end)),abs(y-y(end)),'.-');
    hold(handle,'on'); 
end
legend(str); 