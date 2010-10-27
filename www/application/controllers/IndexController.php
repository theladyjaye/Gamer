<?php
class Foo
{
	public function __call($name, $arguments)
	{
		if($name == 'robofish')
		{
			if(method_exists($this, $name)) 
			{
				return call_user_func_array(array($this, $name), $arguments);
			}
		}
		
		die("No method with name: $name<br/>");
	}
}

class IndexController extends GMRController
{
	protected function initialize_complete()
	{
		//print_r($this->session->currentUser);
		
		$foo = new Foo();
		//$result = method_exists($foo, 'tester');
		echo is_callable(array($foo, 'tester'), false, $name);
		
		echo $name;
		$foo->tester();
		
		//echo $result ? 'HAS METHOD!' : 'NO METHOD';
	}
}


?>