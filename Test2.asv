try
            width  =40;
            %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            low = get(handles.Threadhold,'Min');
            threadhold = get(handles.Threadhold,'Value');
            %show the croped images
            imshow(newCombImg,[low,threadhold],'Parent',handles.ZoomAxes);
        catch
            %width  =5;
            %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            %newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
        end