%current debug mode
%System_Debug
%set to  go_stuck by default when selecting traces

%if handles.System_Debug.Value ==1
%    set(handles.Traces_SetType_List,'Value',3);
%    SetTraceCategory(handles,"Go_Stuck");%setdefault to go stuck
%end