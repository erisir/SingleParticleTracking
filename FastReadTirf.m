function [data] = FastReadTirf(filename)
    %FASTREADTIRF read and load big tif in a faster way
    %   return the raw tif data in 3D stack
    tstack  = Tiff(filename);
    [I,J] = size(tstack.read());
    K = length(imfinfo(filename));
    if CheckGpuSupported()
        data = zeros(I,J,K,'uint16','gpuArray');
    else
        data = zeros(I,J,K,'uint16');
    end
    data(:,:,1)  = tstack.read();
    for n = 2:K
        tstack.nextDirectory()
        data(:,:,n) = tstack.read();
    end
end

