function [supported] = CheckGpuSupported()
%CHECKGPUSUPPORTED 此处显示有关此函数的摘要
%   此处显示详细说明
device = gpuDevice;
supported = ~device.DeviceSupported;
end

