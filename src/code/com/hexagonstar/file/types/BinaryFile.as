/*
			_valid = false;
			_status = Status.INIT;
		// Private Methods
		//-----------------------------------------------------------------------------------------
		 * @private
		 */
		protected function complete():void
		{
			_completeSignal.dispatch(this);