import 'package:flutter/material.dart';

class CaseTrackerPage extends StatefulWidget {
  @override
  _CaseTrackerPageState createState() => _CaseTrackerPageState();
}

class _CaseTrackerPageState extends State<CaseTrackerPage> {
  final TextEditingController _searchController = TextEditingController();
  String _caseNumber = "";
  String _caseName = "";
  String _caseStatus = "";
  String _assignedAdvocate = "";
  bool _isLoading = false;

  void _searchCase() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      if (_searchController.text == '12345') {
        _caseNumber = '12345';
        _caseName = 'Sharma vs. State of Maharashtra';
        _caseStatus = 'In Progress';
        _assignedAdvocate = 'Adv. John Doe';
      } else {
        _caseNumber = '';
        _caseName = 'No case found';
        _caseStatus = '';
        _assignedAdvocate = '';
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Case Number',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Search Button
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: Text('Search Case',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _searchCase,
            ),
            SizedBox(height: 24),

            // Results Section
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _caseNumber.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cases, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No case found',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Case Details',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 16),
                              _buildDetailCard(
                                icon: Icons.numbers,
                                title: 'Case Number',
                                value: _caseNumber,
                              ),
                              _buildDetailCard(
                                icon: Icons.description,
                                title: 'Case Name',
                                value: _caseName,
                              ),
                              _buildDetailCard(
                                icon: Icons.timeline,
                                title: 'Status',
                                value: _caseStatus,
                                statusColor: _getStatusColor(_caseStatus),
                              ),
                              _buildDetailCard(
                                icon: Icons.person,
                                title: 'Assigned Advocate',
                                value: _assignedAdvocate,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Contact Advocate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[800],
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? statusColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (statusColor != null)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.only(right: 8),
                        ),
                      Text(value,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      case 'pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}