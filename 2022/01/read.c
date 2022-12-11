#include <gprolog.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


// compile with
//	-I /usr/share/gprolog/include


int calories_list (const char *fp, int ***list)
{
	FILE *f = fopen (fp, "r");

	int v;
	ssize_t ret;
	char *line;
	size_t len;

	int elves = 0;

	// count number of new lines == elves

	while ((ret = getline (&line, &len, f)) != -1)
	{
		if (strcmp(line, "\n") == 0) elves += 1;
	}

	printf ("%d elves\n", elves);
	*list = malloc (elves * sizeof (int *));

	fseek (f, 0);


	free (line);
	fclose (f);

	return 0;
}

int main (int argc, char **argv)
{
	int ** calories;
	calories_list ("input", &calories);
	free (calories);
	return 0;
}
