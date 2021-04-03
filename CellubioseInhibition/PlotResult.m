paramettersStr =["Velocity(nm/s)";"Run length(nm)";"Processive Moving Duration(s)";"Processive Total BindDuration(s)";...
    "Static Total BindDuration(s)";"Processive Stuck Before Move Duration(s)";"Processive Stuck After Move Duration(s)";"Processive particle Fit Error(nm)"]; 
Concentration = [0,0.5,1,2,4,8,16];

for i = 1:8
    subplot(2,4,i);
    values = zeros(1,7);
    for conId = 1:7
        if isempty(parametters{i,conId})
            continue;
        end
        values(conId) = parametters{i,conId}.Mean;
    end

    plot(Concentration,values);
    hold on;
    plot(Concentration,values,'r*');
    range = ylim;
    ylim([0,range(2)]);
    ylabel(paramettersStr(i));
    xlabel("concentration (mM)");
end