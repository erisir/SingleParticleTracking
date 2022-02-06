function ShowFiducialMarker()
% hObject    handle to ShowFiducialMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;

figure;
handle = subplot(1,1,1);
fiducialIndex = gTraces.Config.fiducialMarkerIndex ;
driftx = gTraces.Config.DriftX;
drifty = gTraces.Config.DriftY;

driftx = driftx - driftx(1);
drifty = drifty - drifty(1);

colNums = ceil(size(fiducialIndex,2)/2);
plot(handle,driftx,drifty,'k ');
hold on;
plot(handle,driftx,drifty,'k*','markersize',10);
str = ["smooth"];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,x-x(1),y-y(1));
    hold(handle,'on'); 
end
legend(str); 