% The following combinations are currently supported 
%(based on http://www.bavaria-direct.co.za/scheme/calculator/)
%  Slots Magnets
%     3     2
%     3     4
%     6     4
%     6     8
%     9     6
%     9     8
%     9     10
%     9     12
%     12    10
%     12    14

% stator, number of slots
nSlots=12;
% rotor, number of magnets
nMagnets=14;



% frequenc of the voltages
voltRotationFreq=0.2; %Hz

% Animation
fileName='12-14.gif';
duration=10;
FPS=12;

MakeDriveAnimation(fileName, FPS, duration, nSlots, nMagnets, voltRotationFreq);
disp('Done.');