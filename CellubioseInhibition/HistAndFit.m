function [retData] = HistAndFit(data,fitOption,bin,xlabelStr)
%PLOTHISTGRAMANDFITGUSSAIN2  do the real plot here
%

%plot
pMarksize = 8;
pLineWidth =1.5;

binstart = bin(1);
binsize = bin(2);
binend = bin(3);
h1 = histogram(data,binstart:binsize:binend);
hold on;
y = h1.Values;
%x = 1:size(y,2);
x = binstart:binsize:(binend-binsize);

yfit = y;
titleStr = sprintf('N:%d, mean:%.2f, median:%.2f',numel(data),mean(data), median(data));
legendStr = "";
retMean = mean(data);
retMedian = median(data);
retFit = -1;
try%try fit bc sometimes data input is not fitable
switch fitOption
    case "gauss1"
        f = fit(x.',y.','gauss1');%f(x) =  a1*exp(-((x-b1)/c1)^2)  
        yfit = f.a1*exp(-((x-f.b1)/f.c1).^2);
        legendStr = sprintf('gauss1: (u????)=%0.2f ?? %0.2f', f.b1, f.c1);
        retFit = f.b1;
    case "gauss2"
        f = fit(x.',y.','gauss2'); %f(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
        yfit = f.a1*exp(-((x-f.b1)/f.c1).^2) + f.a2*exp(-((x-f.b2)/f.c2).^2);
        retFit = f.b1;
        legendStr = sprintf('gauss2(%0.2f ?? %0.2f)(%0.2f ?? %0.2f)', f.b1, f.c1, f.b2, f.c2);
    case "poisson"
        f = fitdist(data,'poisson');
        lambda = f.lambda;
        yfit = zeros(1,size(x,2));
        for i =1:size(x,2)
            temp = i;
            yfit(i) = exp(-1*lambda)*lambda.^temp/factorial(temp);
        end
        legendStr =  sprintf('poisson(lambda) = (%0.2f)',lambda);
    case "exp1"
        [f,r]  = fit(x.',y.','exp1');%f(x) =  a1*exp(-((x-b1)/c1)^2) 
        yfit = f.a*exp(f.b.*x);
        retFit = abs(1/f.b);
        legendStr =  sprintf('exp1: abs(1/t)=%.2f,(RS = %.2f)',abs(1/f.b),r.rsquare);
    case "exp2"
        [f,r]  = fit(x.',y.','exp2');%f(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
        yfit = f.a*exp(f.b.*x)+f.c*exp(f.d.*x);
        yfit1 = f.a*exp(f.b.*x);
        yfit2 = f.c*exp(f.d.*x);
        plot(x,yfit1,'b', 'LineWidth'   , pLineWidth);
        plot(x,yfit2,'g', 'LineWidth'   , pLineWidth);
        retFit = abs(1/f.b);
        legendStr =  sprintf('exp2: abs(1/t1)=%.2f, abs(1/t2)=%0.2f)(RS = %.2f)',abs(1/f.b),abs(1/f.d),r.rsquare);
end


plot(x,yfit,'r', 'LineWidth'   , pLineWidth);
hFit = plot(x,yfit,'r.','MarkerSize',pMarksize);
catch
end

retData.Mean = retMean;
retData.Median=retMedian;
retData.MedianStd = std(data);
retData.Fit = retFit;

plot(x,y,'.b','MarkerSize',pMarksize);

%axis([0,xAxesEnd,0,max(h1.Values)+5]);
xlabel(xlabelStr);
ylabel('Counts');
yaxil = ylim;
ylim([yaxil(1),yaxil(2)*1.1]);
title(titleStr);
%legendStr = '(\mu \pm \sigma)';
%legend( hFit,legendStr);
text( binstart,yaxil(2)*1.01,legendStr);

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

