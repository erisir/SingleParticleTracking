function [] = PlotHistgramAndFitGaussian(plotAxes,data,binsize,xAxesEnd,fitOption,moleculeNums,ylabelName)
%PLOTHISTGRAMANDFITGUSSAIN2  do the real plot here
%    
h1 = histogram(plotAxes,data,0:binsize:xAxesEnd);
y = h1.Values;
x = 1:size(y,2);
x = x*binsize;
str = ['min = ',num2str(min(data),'%.2f'),'  max = ',num2str(max(data),'%.2f'),'  mean = ',num2str(mean(data)),'    N = ',num2str(moleculeNums)];
switch fitOption
    case "gauss1"
        f = fit(x.',y.','gauss1');
        %f(x) =  a1*exp(-((x-b1)/c1)^2)
        yfit = f.a1*exp(-((x-f.b1)/f.c1).^2);
        str = ['y=',num2str(f.a1,'%.2f'),'*exp(-((x-    ',num2str(f.b1,'%.2f'),'   )/',num2str(f.c1,'%.2f'),')^2)   ',str];
        text(plotAxes,floor(f.b1),floor(f.a1),num2str(f.b1,'%.2f'),'Color','r');

    case "gauss2"
        f = fit(x.',y.','gauss2');
        %f(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
        yfit = f.a1*exp(-((x-f.b1)/f.c1).^2) + f.a2*exp(-((x-f.b2)/f.c2).^2);
        str = ['y=',num2str(f.a1,'%.2f'),'*exp(-((x-    ',num2str(f.b1,'%.2f'),'   )/',num2str(f.c1,'%.2f'),')^2) + ',num2str(f.a2,'%.2f'),'*exp(-((x-   ',num2str(f.b2,'%.2f'),'   )/',num2str(f.c2,'%.2f'),')^2  ',str];
        text(plotAxes,floor(f.b1),floor(f.a1),num2str(f.b1,'%.2f'),'Color','r');
        text(plotAxes,floor(f.b2),floor(f.a2),num2str(f.b1,'%.2f'),'Color','r');
end

hold(plotAxes,'on');
if fitOption ~= "None"
    plot(plotAxes,x,yfit,'r');
end
plot(plotAxes,x,y,'.b');
axis(plotAxes,[0,xAxesEnd,0,max(h1.Values)+5]);

title(plotAxes,str);
xlabel(plotAxes,ylabelName) 
ylabel(plotAxes,'counts');
grid(plotAxes,'on');
hold(plotAxes,'off');

end

