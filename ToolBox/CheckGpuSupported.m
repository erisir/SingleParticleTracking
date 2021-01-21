function [supported] = CheckGpuSupported()
%CHECKGPUSUPPORTED  check if the computer supports GPU[CUDA]
%   return false here just for further upgrate
%device = gpuDevice;
supported = 1==0;%~device.DeviceSupported;
end

