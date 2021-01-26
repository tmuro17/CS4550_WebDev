/*
* Design Decisions:
* - You can not perform successive additions by repeatedly pressing
*   plus equals.  In order to add to perform `5 + 5 + 5` you need
*   to press 5 then "+/=" then 5 "+/=" then "+/=" and so on...
* - Negative numbers can only be gotten by subtracting the number
*   from 0.  This can also be done immediately after clearing as
*   the default value in the calculator is 0.
*/

(function () {
  let acc = 0;
  let newNumber = true;
  let operation = null;

  const add_to_display = (num) => {
    const display = document.getElementById("num-display");
    display.value += num;
  };

  const set_display = (num) => {
    const display = document.getElementById("num-display");
    display.value = num;
  };

  const get_display = () => {
    const display = document.getElementById("num-display");
    const val = display.value;
    return parseFloat(val);
  };

  const add_number = (num) => {
    if (newNumber) {
      set_display(num);
    } else {
      add_to_display(num);
    }
    newNumber = false;
  };

  const seven_click = () => add_number(7);
  const eight_click = () => add_number(8);
  const nine_click = () => add_number(9);

  const four_click = () => add_number(4);
  const five_click = () => add_number(5);
  const six_click = () => add_number(6);

  const one_click = () => add_number(1);
  const two_click = () => add_number(2);
  const three_click = () => add_number(3);

  const zero_click = () => add_number(0);
  const dot_click = () => add_number(".");

  const clear_click = () => {
    newNumber = true;
    operation = null;
    acc = 0;
    set_display(0);
  };


  const handle_operation = (op) => {
    operation = op;
    acc = get_display();
    newNumber = true;
  };

  const minus_click = () => handle_operation("minus");
  const times_click = () => handle_operation("times");
  const divide_click = () => handle_operation("divide");

  const plus_equal_click = () => {
    if (operation == null) {
      handle_operation("plus");
    } else {
      const operand = get_display();
      switch (operation) {
        case "plus":
          acc += operand;
          break;
        case "minus":
          acc -= operand;
          break;
        case "times":
          acc *= operand;
          break;
        case "divide":
          acc /= operand;
          break;
      }

      set_display(acc);
      newNumber = true;
      operation = null;
    }
  };

  const add_listener = (elementId, func) => {
    document
      .getElementById(elementId)
      .addEventListener("click", func);
  };

  const register_listeners = () => {
    add_listener("seven", seven_click);
    add_listener("eight", eight_click);
    add_listener("nine", nine_click);

    add_listener("four", four_click);
    add_listener("five", five_click);
    add_listener("six", six_click);

    add_listener("one", one_click);
    add_listener("two", two_click);
    add_listener("three", three_click);

    add_listener("zero", zero_click);
    add_listener("dot", dot_click);

    add_listener("clear", clear_click);

    add_listener("plus-equals", plus_equal_click);
    add_listener("minus", minus_click);
    add_listener("times", times_click);
    add_listener("divide", divide_click);
  };

  const init = () => {
    set_display(0);
    register_listeners();
  };

  window.addEventListener("load", init, false);
})();
