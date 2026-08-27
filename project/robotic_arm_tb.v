`timescale 1ns/1ps

module robotic_arm_tb;

    reg clk;
    reg reset;

    reg [7:0] base_angle;
    reg [7:0] shoulder_angle;
    reg [7:0] elbow_angle;
    reg [7:0] gripper_angle;

    wire base_pwm;
    wire shoulder_pwm;
    wire elbow_pwm;
    wire gripper_pwm;

    robotic_arm #(
        .CLK_FREQ(1_000_000),
        .PWM_FREQ(50)
    ) uut (
        .clk(clk),
        .reset(reset),

        .base_angle(base_angle),
        .shoulder_angle(shoulder_angle),
        .elbow_angle(elbow_angle),
        .gripper_angle(gripper_angle),

        .base_pwm(base_pwm),
        .shoulder_pwm(shoulder_pwm),
        .elbow_pwm(elbow_pwm),
        .gripper_pwm(gripper_pwm)
    );

    // 1 MHz clock
    always #500 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        base_angle     = 8'd90;
        shoulder_angle = 8'd90;
        elbow_angle    = 8'd90;
        gripper_angle  = 8'd90;

        #2000;

        reset = 0;

        $display("Robotic Arm Simulation Started");
        $display("Base     = %d degrees", base_angle);
        $display("Shoulder = %d degrees", shoulder_angle);
        $display("Elbow    = %d degrees", elbow_angle);
        $display("Gripper  = %d degrees", gripper_angle);

        // Move arm
        #20000;

        base_angle     = 8'd45;
        shoulder_angle = 8'd120;
        elbow_angle    = 8'd60;
        gripper_angle  = 8'd30;

        $display("Arm moved to new position");
        $display("Base     = %d degrees", base_angle);
        $display("Shoulder = %d degrees", shoulder_angle);
        $display("Elbow    = %d degrees", elbow_angle);
        $display("Gripper  = %d degrees", gripper_angle);

        #20000;

        $display("Simulation completed.");

        $finish;
    end

endmodule
