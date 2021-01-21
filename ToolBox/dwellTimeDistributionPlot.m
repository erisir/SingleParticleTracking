
Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];

nums_PGE = [5481,80,217,172,46,135,187,52,60,3658];
flag = "12";

if flag == "12"
    v1_1st
     for i = 1:22
         if v1_1st(i)<v1_2ed(i)
              t = v1_1st(i);
              v1_1st(i)=v1_2ed(i);
              v1_2ed(i) = t;              
         end
     end
     v1_1st
     for i = 1:52
         if v2_1st(i)<v2_2ed(i)
              t = v2_1st(i);
              v2_1st(i)=v2_2ed(i);
              v2_2ed(i) = t;              
         end
     end
end
if flag == "pie1"
    figure;
    pie([84.29,6.1,4.8,6.82],[0,0,2,2]);
    %pie([92.2,3.1,5.36,4.5],[0,0,2,2]);
    legend({"land-stick","land-stick-move","land-move","other"});
end
if flag == "pie3"
    figure;
     
    fration2nM = [15.5+66.8+1.1,1,0.5+3.14+2.46];
    fration10nM = [5.15+82.18+2.8,2.07,0.73+2.73+2.78];
    fration = fration10nM;
    pie(fration/sum(fration),[0,0,2]);%10 nm
    legend({"land-stick(Bleach/detach)","land-stick-detach","land-stuck-move"});
end
if flag == "pie4"
    figure;
     
    fration2nM = [3.14+0.84,3.96,0.5,2.46,0.95];
    fration10nM = [2.73+1.08,4.27,0.73,2.78,0.45];
    fration = fration2nM;
    pie(fration/sum(fration),[1,1,1,1,1]);%10 nm
    legend({"move-stuck(repeat-detach)","move-stuck","move-detach","random-walk","moveback"});
end

if flag == "bar"
    label = ["velocity","RunLength","duration-Move","duration-Stuck"];
 Cel7a_2nM_min = [0.15;7;10.38;9.34];
    Cel7a_2nM_max = [31.03;259.06;911.96;1037.66];
    Cel7a_2nM_mean = [4.7;36.1;182.1;156];
    Cel7a_2nM_median = [3;26.7;118.8;80.1];
    
    Cel7a_10nM_min = [0.11;8.92;9.34;9.34];
    Cel7a_10nM_max = [37.1;235.7;903.7;976.3];
    Cel7a_10nM_mean = [4.6;42.7;187.8;165.1];
    Cel7a_10nM_median = [3.26;32.7;144.2;98.56];
    figure;
    % velocity,  runlength,  duration-Move , duration-Stuck
    %bar([Cel7a_2nM_min,Cel7a_2nM_max,Cel7a_2nM_mean,Cel7a_2nM_median;Cel7a_10nM_min,Cel7a_10nM_max,Cel7a_10nM_mean,Cel7a_10nM_median]);
    subplot(2,2,1);bar([Cel7a_2nM_min,Cel7a_10nM_min]);title("min    value ");
    subplot(2,2,2);bar([Cel7a_2nM_max,Cel7a_10nM_max]);title("max    value ");
    subplot(2,2,3);bar([Cel7a_2nM_mean,Cel7a_10nM_mean]);title("mean    value ");
    subplot(2,2,4);bar([Cel7a_2nM_median,Cel7a_10nM_median]);title("median    value ");
end
 