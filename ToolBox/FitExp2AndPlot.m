function [] = FitExp2AndPlot(data,startTime,step,endTime,Labelx,labelY)
%FITEXP1ANDPLOT Summary of this function goes here
%   Detailed explanation goes here
    x = startTime:step:endTime;
    h1 = histogram(data,x);    
    y = h1.Values;  
    [f,r] = fit(x',[y,0]','exp2');    
    hold on;    
    plot(x,f.a*exp(f.b.*x),'r','linewidth',1.2);
    plot(x,f.c*exp(f.d.*x),'g','linewidth',1.2);
    plot(x,f.a*exp(f.b.*x)+f.c*exp(f.d.*x),'k','linewidth',1.5);
     
    spacer = max(y)/10;
    textXPos = max(x)/10;
    textYPos = max(y)-spacer;
    text(textXPos,textYPos ,['N=',num2str(max(size(data))),'  ;bin =',num2str(step)]);
    text(textXPos,textYPos-spacer,['f(x) =A* exp(',num2str(f.b,4),' x)+']);
    text(textXPos,textYPos-2*spacer,['    B * exp(',num2str(f.d,4),' x)']);
    text(textXPos,textYPos-3*spacer,['    RS = ',num2str(r.rsquare,4)]);
    text(textXPos,textYPos-4*spacer,['1/t1 = ',num2str(1/abs(f.b),5),'; 1/t2 = ',num2str(1/abs(f.d),5)]);
    xlabel(Labelx);
    ylabel(labelY);
    hold off;
end

