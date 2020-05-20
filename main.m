clear all;
close all;
clc;
% Example code simulates the same RL circuit (different component values) given in the following link
% https://medium.com/@amattmiller/running-ltspice-from-matlab-630d551032cc.
% Here we generate the netlist and do the full simulation using MATLAB
% only.


%%Initialize the paths

spicePath = 'C:\Program Files\LTC\LTspiceXVII\start.exe'; % This is the path to your LT Spice installation
filePath = 'G:\Shared drives\Power Electronics Materials\LTSpice\'; %This is the path where you want the netlist, functions and simulation outputs to reside
netPath = 'G:\\Shared drives\\Power Electronics Materials\\LTSpice\\'; % THis is same as file path but all \ are replaced by \\ because of some Matlab issue in writing Netlist.

%% Simple RL circuit example
fileName = 'example';
Res = 10e3;
Cap = 160e-12;
Vmax = 1;
f = 60;
endtime =0.1;
analysistype = 'tran';

%% Create Net list
% Set the path string
pathString = sprintf('* %s%s.asc',netPath, fileName);

% Components
components(1) = makeComponent('R1', 'Vo', 'Vi', '{R}');
components(2) = makeComponent('C1', 'Vo', '0', '{C}');
components(3) = makeComponent('V1', 'Vi', '0', 'SINE(0 {ampl} {freq}');

for i = 1:length(components)
components(i).string = sprintf('%s %s %s %s', components(i).name,components(i).startNode,components(i).endNode,components(i).type);
end
compString = components(1).string;
for i = 2:length(components)
    compString = sprintf('%s\r\n%s',compString,components(i).string);
end

% Set parameters
paramString = sprintf('.params R = %d C = %d ampl = %d freq = %d', Res, Cap, Vmax, f);

% Set the analysis
analysisString = sprintf('.%s %s', analysistype, endtime);

% Put the end strings
endString = sprintf('.backanno\r\n.end\r\n');

% Generate the Netlist and write to file
netList = sprintf('%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n',pathString,compString,paramString,analysisString,endString); 
netName = sprintf('%s.net',fileName);
fileID = fopen(netName,'w');
fprintf(fileID,netList);
fclose('all');

% Run the simulation
result = simulateModel(spicePath, fileName, filePath);
