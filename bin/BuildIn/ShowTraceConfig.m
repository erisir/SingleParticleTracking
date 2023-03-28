function ShowTraceConfig(handles)
%SHOWTRACECONFIG Summary of this function goes here
%   Detailed explanation goes here
global gTraces;
titleStr = "ShowTraceConfig";
if ~isfield(gTraces,'Config')
    msgbox("No Config found in import data",titleStr);
    return;
end
Config = gTraces.Config;
message = [];
emptyStr = "--------------------------------------------------------------------------";
newlineStr = ".";
message = [message;strcat("Version = ",string(Config.Version))];
message = [message;newlineStr];
message = [message;strcat("StackName = ","")];
message = [message;newlineStr];
message = [message;strcat("    ",string(Config.StackName))];

message = [message;emptyStr];

message = [message;strcat("UsingDefaultConfig = ",string(Config.UsingDefault))];

message = [message;newlineStr];
message = [message;"Movie"];
message = [message;emptyStr];

message = [message;strcat("pixelSize = ",string(Config.pixelSize))];
message = [message;strcat("TimeDifferent = ",string(Config.ExpusureTimems))];
message = [message;strcat("FirstFrame  = ",string(Config.FirstFrame))];
message = [message;strcat("LastFrame = ",string(Config.LastFrame))];

message = [message;newlineStr];
message = [message;"FitModel"];
message = [message;emptyStr];


message = [message;strcat("FitModel = ",string(Config.Model))];
message = [message;strcat("GpuAccelerate = ",string(Config.GpuAccelerate))];
message = [message;strcat("MaxVelocity = ",string(Config.MaxVelocity))];
message = [message;strcat("Weight:Position = ",string(Config.Position))];
message = [message;strcat("Weight:Direction = ",string(Config.Direction))];
message = [message;strcat("Weight:Speed = ",string(Config.Speed))];

message = [message;newlineStr];
message = [message;"Connect Tracks"];
message = [message;emptyStr];


message = [message;strcat("MinLength = ",string(Config.MinLength))];
message = [message;strcat("MaxBreak = ",string(Config.MaxBreak))];
message = [message;strcat("MaxAngle = ",string(Config.MaxAngle))];

message = [message;emptyStr];

msgbox(message,titleStr);

end

