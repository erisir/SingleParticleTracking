Results = Molecule(1).Results;
frame = Results(:,1);
y = Results(:,4);
drift = C5;
ydrift = y - smooth(drift(frame),35);
ydrift = ydrift - min(ydrift);
plot(frame/20000,ydrift);
hold on;
plot(frame/20000,smooth(ydrift,20));
yticks(0:16:7000)
grid on