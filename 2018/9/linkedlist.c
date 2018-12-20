struct marble
{
		int value;
		int position;

		struct marble* next;
		struct marble* prev;
};


struct marble* addAfter(struct marble* current, int value)
{
		// at the start we have a node with a next and a prev
		// gotta get the next node so that we can alter its prev pointer
		struct marble* newMarble = malloc(sizeof(struct marble));
		
		struct marble* next = current->next;

		newMarble->value = value;
		newMarble->next = next;
		newMarble->prev = current;

		next->prev = newMarble;
		current->next = newMarble;

		return newMarble;

}

struct marble* deleteCurrent(struct marble* current)
{
		struct marble* next = current->next;
		struct marble* prev = current->prev;

		// link next and prev
		next->prev = prev;
		prev->next = next;
	
		// free the current
		free(current);

		// if we are the only marble (i.e. next = prev = me) then return null
		if( prev == next )
		{
				return NULL;
		}
		// return the previous one
		return prev;
}

void deleteAllMarbles(struct marble* _current)
{
		struct marble* current = _current;
		while( current != NULL )
		{
				current = deleteCurrent(current);
		}
}

void printList(struct marble* _current)
{
		struct marble* current = _current;
		printf("List: [ ");
		do
		{
				printf("%d ", current->value);
				current = current->next;
		}
		while (current != _current);
		printf("]\n");
}

