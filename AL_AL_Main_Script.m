clc 
close all
clear

% Inputs
skin_thick_range = linspace (3,6,12);
stringer_thick_range = linspace (3,6,12);
crown_width_range = linspace (35,50,12);


% DOE 
doe_design_param = fullfact ([12 12 12]);
design_param_list=zeros(length(doe_design_param),3);
design_param_list_display=zeros(length(doe_design_param),3);%initialization

for i=1: length(doe_design_param)

    design_param_list(i,:) = [crown_width_range(doe_design_param(i,1)), ...
                              skin_thick_range(doe_design_param(i,2)),  ...
                              stringer_thick_range(doe_design_param(i,3)) ];

    design_param_list_display(i,:) = [skin_thick_range(doe_design_param(i,1)),  ...
                        stringer_thick_range(doe_design_param(i,2)) , ...
                        crown_width_range(doe_design_param(i,3)) ];

end


var.time=1:1728;
var.signals.values=design_param_list;

 sim AL_AL_FMU.slx

% 4 Pillars- Except Performance

e_skin=12.99;       % 12.99 for AL, 57.285 for CFRP, 44.289 for titanium, 57.985 for CFPEEK for no use phase
e_stringer=12.99;
c_skin=7298.193;        % 5.49 for AL, 190.98 for CFRP, 44.95 for titanium, 262.18 for CFPEEK for no use phase
c_stringer=7298.193;


m_skin=zeros(length(doe_design_param), 1);       % Initialization
m_stringer=zeros(length(doe_design_param), 1);

env_skin=zeros(length(doe_design_param), 1);      
env_stringer=zeros(length(doe_design_param), 1);

cost_skin=zeros(length(doe_design_param), 1);
cost_stringer=zeros(length(doe_design_param), 1);

env=zeros(length(doe_design_param), 1);
cost=zeros(length(doe_design_param), 1);

circ=zeros(length(doe_design_param), 1);
soc=zeros(length(doe_design_param), 1);

td=zeros(length(doe_design_param), 1);
eig=zeros(length(doe_design_param), 1);
sf=zeros(length(doe_design_param), 1);





for i=1:length(doe_design_param)

    sf(i)=ans.SI_results.signals.values(i+1,4);  %Safety Factor

    td(i)=ans.SI_results.signals.values(i+1,5);
    eig(i)=ans.SI_results.signals.values(i+1,3); %Performance Parameters 

    m_skin(i)=ans.SI_results.signals.values(i+1,1);
    m_stringer(i)=ans.SI_results.signals.values(i+1,2);


    env_skin(i)=e_skin.*m_skin(i);
    env_stringer(i)=e_stringer.*m_stringer(i);

    env(i)=env_skin(i)+env_stringer(i);   %Environmental Impact Pillar


    cost_skin(i)=c_skin.*m_skin(i);
    cost_stringer(i)=c_stringer.*m_stringer(i);

    cost(i)=cost_skin(i)+cost_stringer(i);  % Cost Pillar


    circ(i)=1;     % Circularity Pillar    1 for AL-AL, 0.5 for CFRP-AL/AL-CFRP/Ti-CFRP, 0 for CFRP-CFRP, 0.426 for CFPEEK-CFPEEK


    soc(i)=0.9767; % Social Impact Pillar  1 for AL-AL, 0.885 for AL-CFRP/CFRP-AL, 0.910 for Ti /CFRP, 0.962 for CFRP-CFRP, 0.936 for CFPEEK-CFPEEK



end

% Export the file

A=[design_param_list_display,sf,td,eig,cost,env,circ,soc,m_skin,m_stringer];

rows=A(:,4) >= 1.15 & A(:, 4) <= 1.5;

AL_AL=A(rows,:); 

writematrix(AL_AL,'AL-AL-HYDROGEN.xlsx')


