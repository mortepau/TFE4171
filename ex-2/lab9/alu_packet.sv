//Make your struct here
typedef struct
{
	rand bit[0:7] a;
	rand bit[0:7] b;
	rand bit[0:2] op;
} data_t;

class alu_data;
        //Initialize your struct here
	rand data_t data;

        // Class methods(tasks) go here
	task get(output bit[0:7] a, b, output bit[0:2] op);
		a = data.a;
		b = data.b;
		op = data.op;
		$display($stime,,,"alu_packet:: a=%b, b=%b, op=%b\n", a, b, op);
	endtask

        // Constraints
	constraint c1 { data.a inside {[0:127]}; }
	constraint c2 { data.b inside {[0:255]}; }
	constraint c3 { data.op inside {[0:6]}; }

endclass: alu_data

