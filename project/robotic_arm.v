module robotic_arm #(
    parameter CLK_FREQ = 50_000_000,
    parameter PWM_FREQ = 50
)(
    input  wire       clk,
    input  wire       reset,

    input  wire [7:0] base_angle,
    input  wire [7:0] shoulder_angle,
    input  wire [7:0] elbow_angle,
    input  wire [7:0] gripper_angle,

    output reg        base_pwm,
    output reg        shoulder_pwm,
    output reg        elbow_pwm,
    output reg        gripper_pwm
);

    localparam integer PWM_PERIOD = CLK_FREQ / PWM_FREQ;

    reg [31:0] pwm_counter;

    reg [31:0] base_duty;
    reg [31:0] shoulder_duty;
    reg [31:0] elbow_duty;
    reg [31:0] gripper_duty;

    // Convert angle (0-180 degrees) to servo pulse width.
    // Approximate servo range: 1 ms to 2 ms.
    always @(*) begin
        base_duty =
            (PWM_PERIOD / 1000) +
            ((PWM_PERIOD / 1000) * base_angle / 180);

        shoulder_duty =
            (PWM_PERIOD / 1000) +
            ((PWM_PERIOD / 1000) * shoulder_angle / 180);

        elbow_duty =
            (PWM_PERIOD / 1000) +
            ((PWM_PERIOD / 1000) * elbow_angle / 180);

        gripper_duty =
            (PWM_PERIOD / 1000) +
            ((PWM_PERIOD / 1000) * gripper_angle / 180);
    end

    // PWM counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pwm_counter <= 0;

            base_pwm     <= 0;
            shoulder_pwm <= 0;
            elbow_pwm    <= 0;
            gripper_pwm  <= 0;
        end
        else begin

            if (pwm_counter >= PWM_PERIOD - 1)
                pwm_counter <= 0;
            else
                pwm_counter <= pwm_counter + 1;

            if (pwm_counter < base_duty)
                base_pwm <= 1;
            else
                base_pwm <= 0;

            if (pwm_counter < shoulder_duty)
                shoulder_pwm <= 1;
            else
                shoulder_pwm <= 0;

            if (pwm_counter < elbow_duty)
                elbow_pwm <= 1;
            else
                elbow_pwm <= 0;

            if (pwm_counter < gripper_duty)
                gripper_pwm <= 1;
            else
                gripper_pwm <= 0;
        end
    end

endmodule
