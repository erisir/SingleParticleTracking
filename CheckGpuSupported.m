function [supported] = CheckGpuSupported()
%CHECKGPUSUPPORTED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
device = gpuDevice;
supported = ~device.DeviceSupported;
end

