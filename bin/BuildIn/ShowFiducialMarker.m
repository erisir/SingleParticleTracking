function ShowFiducialMarker()
% hObject    handle to ShowFiducialMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;

figure;
handle = subplot(1,1,1);
fiducialIndex = gTraces.Config.fiducialMarkerIndex ;
driftx = gTraces.driftx;
drifty = gTraces.drifty;

driftx = abs(driftx - driftx(end));
drifty = abs(drifty - drifty(end));

colNums = ceil(size(fiducialIndex,2)/2);
plot(handle,driftx,drifty,'.-k ','LineWidth',3,'MakerSize',6);
hold on;
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