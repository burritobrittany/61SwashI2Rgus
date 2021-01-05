%%intrinsicsExtrinsicsToP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function creates a camera P matrix from a specified camera EO and
%  IO from beta and LCP respectively. 
  

%  Reference Slides:
%  

%  Input:
%  intrinsics = 1x11 Intrinsics Vector Formatted as in A_formatIntrinsics

%  extrinsics = 1x6 Vector representing [ x y z yaw pitch roll] of the camera.
%  XYZ should be in the same units as xyz points to be converted and yaw,
%  pitch, and roll should be in radians. 


%  Output:
%  P= [4 x 4] transformation matrix to convert XYZ coordinates to distorted
%  UV coordinates. 


%  Required CIRN Functions:
%  None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P = intrinsicsExtrinsics2Pmod( intrinsics, xyzc,R )


%% Section 1: Format IO into K matrix
fx=intrinsics(5);
fy=intrinsics(6);
c0U=intrinsics(3);
c0V=intrinsics(4);

K = [-fx 0 c0U;
     0 fy c0V;
     0  0 1];

 
 
 
 
%% Section 2: Format EO into Rotation Matrix R






%% Section 3: Format EO into Translation Matrix
x=xyzc(1);
y=xyzc((2));
z=xyzc((3));

IC = [eye(3) [-x -y -z]'];





%% Section 4: Combine K, Rotation, and Translation Matrix into P 
P = K*R*IC;
P = P/P(3,4);   % unnecessary since we will also normalize UVs





%% Copyright Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key UAVProcessingToolbox
