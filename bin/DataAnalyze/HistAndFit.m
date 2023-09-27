function [retData] = HistAndFit(data,fitOption,bin,xlabelStr)
%PLOTHISTGRAMANDFITGUSSAIN2  do the real plot here
%

%plot
dataSize = numel(data);
if dataSize<10
    return
end
pLineWidth = 2;
legendStr = "";
retData.size = numel(data);
retData.Mean =  mean(data);
retData.Median= median(data);
retData.Std = std(data);
binstart = bin(1);
binsize = bin(2);
binend = bin(3);

%prepare data, pdf or cdf
    switch fitOption
        case {"gauss1","gauss2","poisson"}
            %pdf start

            hold off;
            h1 = histogram(data,binstart:binsize:binend);
            pdfy = h1.Values;
            normalizedY = pdfy/max(pdfy);

            pdfx = binstart:binsize:(binend-binsize);
            pdfy = normalizedY;
            %pdf end
        case {"exp1","exp2"}
            %cdf start
            [yy,xx,~,~,eid] = cdfcalc(data);
            % Create vectors for plotting
            k = length(xx);
            n = reshape(repmat(1:k, 2, 1), 2*k, 1);
            xCDF    = [-Inf; xx(n); Inf];
            yCDF    = [0; 0; yy(1+n)];

            cdfx = xCDF';
            cdfy = yCDF';
            cdfx(end) = [];
            cdfx(1) = [];
            cdfy(end) = [];
            cdfy(1) = [];
            cdfy = max(cdfy) - cdfy;

            %cdf end
    end

yfit = [];

%titleStr = sprintf('N:%d, mean:%.2f, median:%.2f',numel(data),mean(data), median(data));
titleStr = sprintf('N:%d, mean:%.2f, std:%.2f, bin:%.1f,',retData.size,retData.Mean,retData.Std,binsize);


try%try fit bc sometimes data input is not fitable
    switch fitOption
        case "gauss1"       
            f = fit(pdfx.',pdfy.','gauss1');%f(x) =  a1*exp(-((x-b1)/c1)^2)  
            yfit = f.a1*exp(-((pdfx-f.b1)/f.c1).^2);
            legendStr = sprintf('gauss1: u=%0.2f sigma %0.2f', f.b1, f.c1);

        case "gauss2"
            f = fit(pdfx.',pdfy.','gauss2'); %f(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
            yfit = f.a1*exp(-((pdfx-f.b1)/f.c1).^2) + f.a2*exp(-((pdfx-f.b2)/f.c2).^2);
            legendStr = sprintf('gauss2(u %0.2f sigma %0.2f)(u%0.2f sigma %0.2f)', f.b1, f.c1, f.b2, f.c2);

        case "poisson"
            f = fitdist(data','poisson');
            lambda = f.lambda;
            yfit = zeros(1,size(pdfx,2));
            for i =1:size(pdfx,2)
                temp = i;
                yfit(i) = exp(-1*lambda)*lambda.^temp/factorial(temp);
            end
            legendStr =  sprintf('poisson(lambda) = (%0.2f)',lambda);
        case "exp1"
            [f,r]  = fit(cdfx.',cdfy.','exp1');%f(x) =  a1*exp(-((x-b1)/c1)^2) 
            x = 0:0.5:max(cdfx);
            yfit = f.a*exp(f.b.*x);
            cutoff = 10;
            ind = find(x<cutoff);
            sumLower = sum(yfit(ind));
            sumHighterAndEq = sum(yfit) - sumLower;
            
            hold off;
            plot(cdfx,cdfy,'k.');
            hold on;
            tempx = ones(1,100);
            tempy = max(yfit)*(1:100)/100;
            plot(cutoff*tempx,tempy,'g-');
            plot(x,yfit,'r.-');
            legendStr =  sprintf('exp1: T=%.2f,rs=%.2f, lower/higher = %.1f ',abs(1/f.b),r.rsquare,sumLower*100/sumHighterAndEq);       
        case "exp2"
            [f,r]  = fit(cdfx.',cdfy.','exp2');%f(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
            yfit = f.a*exp(f.b.*cdfx)+f.c*exp(f.d.*cdfx);
           
            yfit1 = f.a*exp(f.b.*cdfx);
            yfit2 = f.c*exp(f.d.*cdfx);
            hold off;
            plot(cdfx,cdfy,'k.');
            
            hold on;
            plot(cdfx,yfit,'r.');
            plot(cdfx,yfit1,'g-','lineWidth',0.5);            
            plot(cdfx,yfit2,'g-','lineWidth',0.5);
 
            legendStr =  sprintf('exp2: abs(1/t1)=%.2f, abs(1/t2)=%0.2f)(RS = %.2f)',abs(1/f.b),abs(1/f.d),r.rsquare);
    end
    
    switch fitOption
        case {"gauss1","gauss2","poisson"}
            hold off;
            bar(pdfx,pdfy);
            hold on;
            plot(pdfx,yfit, 'LineWidth'   , pLineWidth);      
            ylabel('Probability');
        case {"exp1","exp2"}
            ylabel('1-cdf');
    end

catch
    donothing = "nothing"
end

xlabel(xlabelStr);

yaxil = ylim;
ylim([yaxil(1),yaxil(2)*1.1]);
title(titleStr);
text(binstart,yaxil(2)*1.01,legendStr);

grid('on');
hold('off');

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.01 .01] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );


end

