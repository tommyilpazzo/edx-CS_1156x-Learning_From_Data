clc;

n = 20;

errlimit = 1e-14;

u = 1;
v = 1;

eta = 0.1;

err = (u*exp(v) - 2*v*exp(-u))^2;

%plot surface
[x,y] = meshgrid(linspace(0,10,100));
E = (x*exp(y) - 2*y*exp(-x))^2;
surf(x,y,real(E),'linestyle','none','facealpha',0.4);
xlabel('u');
ylabel('v');
zlabel('e');

fprintf('Iteration: %i, u: %d, v: %d E: %d\n', 0, u, v, err)

for i = 1:n
   
   unew = u - eta * (2 * (exp(v) + 2*v*exp(-u)) * (u*exp(v) - 2*v*exp(-u)));
   vnew = v - eta * (2 * (u*exp(v) - 2*exp(-u)) * (u*exp(v) - 2*v*exp(-u)));
   
   u = unew;
   v = vnew;
   
   err = (u*exp(v) - 2*v*exp(-u))^2;
      
   fprintf('Iteration: %i, u: %d, v: %d E: %d\n', i, u, v, err)
   
   if err < errlimit
        break;
   end
   
end

