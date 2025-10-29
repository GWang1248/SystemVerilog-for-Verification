//Sole Random
class MemoryBlockPureRandom;

	//Start and End address of RAM
	bit [31:0] m_ram_start;
	bit [31:0] m_ram_end;

	//Start and end address of the random block
	rand bit [31:0] m_start_addr;
	rand bit [31:0] m_end_addr;
	rand int m_block_size;

	//Constraints on memory block compared with RAM
	constraint c_addr {
		m_start_addr >= m_ram_start;
		m_end_addr <= m_ram_end;
		m_start_addr % 4 == 0;
		m_end_addr == m_start_addr + m_block_size - 1;
	}

	function void display();
    	$display ("------ Memory Block --------");
    	$display ("RAM StartAddr   = 0x%0h", m_ram_start);
    	$display ("RAM EndAddr     = 0x%0h", m_ram_end);
		$display ("Block StartAddr = 0x%0h", m_start_addr);
    	$display ("Block EndAddr   = 0x%0h", m_end_addr);
    	$display ("Block Size      = %0d bytes", m_block_size);
  	endfunction
endclass

//Equal Partition
class MemoryBlockEqualPartition;

	//Start and End address of RAM
	bit [31:0] m_ram_start;
	bit [31:0] m_ram_end;

	//Number of partition, start address and size of each
	rand int m_num_part;
	rand bit [31:0] m_part_start [];
	rand int m_part_size;
	rand int m_tmp;

	constraint c_parts { m_num_part > 4; m_num_part < 10; }

	constraint c_size { m_part_size == (m_ram_end - m_ram_start) / m_num_part; }

	constraint c_part {
		m_part_start.size() == m_num_part; //Let number of element equals to how many partition it generates
		foreach(m_part_start[i]){
			if (i)
				m_part_start[i] == m_part_start[i - 1] + m_part_size;
			else
				m_part_start[i] == m_ram_start; //When i = 0, Starting position of block starts at the beginning of ram block
		}
	}

	function void display();
    	$display ("------ Memory Block --------");
    	$display ("RAM StartAddr   = 0x%0h", m_ram_start);
    	$display ("RAM EndAddr     = 0x%0h", m_ram_end);
    	$display ("# Partitions = %0d", m_num_part);
    	$display ("Partition Size = %0d bytes", m_part_size);
    	$display ("------ Partitions --------");
    	foreach (m_part_start[i])
      		$display ("Partition %0d start = 0x%0h", i, m_part_start[i]);
  endfunction
endclass